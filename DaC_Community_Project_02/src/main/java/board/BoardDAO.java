package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/dac";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";

    public Connection getConnection() throws SQLException {
        Connection connection = null;
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        }
        return connection;
    }

    // 리소스 닫기
    public void close(Connection con, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
        }
    }
    
    // 게시글 가져오기
    public BoardDTO getBoard(int boardId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        BoardDTO board = null;

        try {
            con = getConnection();
            String sql = "SELECT * FROM board WHERE num = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, boardId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                board = extractBoardFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
        } finally {
            close(con, pstmt, rs);
        }

        return board;
    }

    private BoardDTO extractBoardFromResultSet(ResultSet rs) throws SQLException {
        BoardDTO board = new BoardDTO();
        board.setNum(rs.getInt("num"));
        board.setId(rs.getString("id"));
        board.setWriter(rs.getString("writer"));
        board.setSubject(rs.getString("subject"));
        board.setRegDate(rs.getString("reg_date"));
        board.setReadcount(rs.getInt("readcount"));
        board.setRef(rs.getInt("ref"));
        board.setReStep(rs.getInt("re_step"));
        board.setReLevel(rs.getInt("re_level"));
        board.setContent(rs.getString("content"));
        board.setIp(rs.getString("ip"));
        board.setStatus(rs.getInt("status"));
        return board;
    }
    
    // 현재 시간 가져오기
    public String getCurrentDateTime() {
        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement("SELECT NOW()");
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
        }
        return null;
    }

    // 게시글 개수 가져오기
    public int getBoardCount() {
        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement("SELECT COUNT(*) FROM board");
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
        }
        return 0;
    }
    
    // 리스트 출력
    public List<BoardDTO> getBoardListDescending(int startRow, int endRow, int parentId) {
        List<BoardDTO> boardList = new ArrayList<>();
        try (Connection con = getConnection();
            PreparedStatement pstmt = con.prepareStatement("SELECT * FROM (SELECT *, CASE WHEN re_step = 0 THEN num ELSE ref END AS parentNum, ROW_NUMBER() OVER (ORDER BY parentNum DESC, re_step ASC) AS rnum FROM board) AS temp WHERE (parentNum = ? OR (ref = ? AND parentNum = 0)) OR status = 1 AND rnum BETWEEN ? AND ?")) {
            pstmt.setInt(1, parentId);
            pstmt.setInt(2, parentId);
            pstmt.setInt(3, startRow);
            pstmt.setInt(4, endRow);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    boardList.add(extractBoardFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
        }
        return boardList;
    }

    // 게시글 작성
    public int insertBoard(BoardDTO board) {
        try (Connection con = getConnection();
            PreparedStatement pstmt = con.prepareStatement("INSERT INTO board (id, writer, subject, reg_date, readcount, ref, re_step, re_level, content, ip, status) VALUES (?, ?, ?, NOW(), 0, ?, ?, ?, ?, ?, ?)")) {
            
            // 부모 글의 번호를 가져옵니다.
            int parentId = board.getRef();

            // 부모 글이 없으면(새 글인 경우)
            if (parentId == 0) {
                // ref 값을 0으로 설정합니다.
                pstmt.setInt(4, 0);
                // 답변 순서와 레벨은 0으로 설정합니다.
                pstmt.setInt(5, 0);
                pstmt.setInt(6, 0);
            } else {
                // 답글인 경우에는 부모 글의 ref 값을 사용합니다.
                pstmt.setInt(4, parentId);
                // 답글의 답변 순서와 레벨을 설정합니다.
                // 해당 부모 글의 마지막 답변 순서를 가져옵니다.
                int lastReStep = getLastReStep(con, parentId);
                pstmt.setInt(5, lastReStep + 1);
                // 답글의 레벨은 부모 글의 레벨 + 1로 설정합니다.
                pstmt.setInt(6, board.getReLevel() + 1);
            }

            // 나머지 필드 값들을 설정합니다.
            pstmt.setString(1, board.getId());
            pstmt.setString(2, board.getWriter());
            pstmt.setString(3, board.getSubject());
            pstmt.setString(7, board.getContent());
            pstmt.setString(8, board.getIp());
            pstmt.setInt(9, board.getStatus());

            // 쿼리를 실행하고 결과를 반환합니다.
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
        }
        return 0;
    }


    // 답글달기 메소드
    public int reply(int parentId, BoardDTO board) {
        Connection con = null;
        PreparedStatement pstmt = null;
        int result = 0; // 성공 여부를 나타내는 값

        try {
            con = getConnection();
            con.setAutoCommit(false); // 트랜잭션 시작

            // 해당 부모글의 정보 가져오기
            BoardDTO parentBoard = getBoard(parentId);

            // 해당 부모글의 답글 중에서 마지막 순서(re_step) 찾기
            int lastReStep = getLastReStep(con, parentId);

            // 새로운 답글의 순서와 깊이 설정
            board.setRef(parentId);
            board.setReStep(lastReStep + 1);
            board.setReLevel(parentBoard.getReLevel() + 1);

            // 해당 게시물의 답글 순서(reStep)를 업데이트합니다.
            updateReStep(con, parentBoard.getRef(), board.getReStep());

            // 답글을 작성합니다.
            String sql = "INSERT INTO board (id, writer, subject, reg_date, readcount, ref, re_step, re_level, content, ip, status) "
                    + "VALUES (?, ?, ?, NOW(), 0, ?, ?, ?, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, board.getId());
            pstmt.setString(2, board.getWriter());
            pstmt.setString(3, board.getSubject());
            pstmt.setInt(4, board.getRef()); // ref 값 설정
            pstmt.setInt(5, board.getReStep());
            pstmt.setInt(6, board.getReLevel());
            pstmt.setString(7, board.getContent());
            pstmt.setString(8, board.getIp());
            pstmt.setInt(9, board.getStatus());

            // 쿼리를 실행하고 결과를 반환합니다.
            result = pstmt.executeUpdate();

            // 커밋
            con.commit();
        } catch (SQLException e) {
            // 롤백
            try {
                if (con != null) con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace(); // 또는 로깅
        } finally {
            // 리소스 해제
            close(con, pstmt, null);
        }
        return result;
    }

    
    // 해당 게시물의 답글 순서(reStep)를 업데이트하는 메서드
    private void updateReStep(Connection con, int ref, int reStep) throws SQLException {
        String sql = "UPDATE board SET re_step = re_step + 1 WHERE ref = ? AND re_step > ?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, ref);
            pstmt.setInt(2, reStep);
            pstmt.executeUpdate();
        }
    }

    // 해당 부모글의 답글 중에서 마지막 순서(re_step) 찾기
    private int getLastReStep(Connection con, int parentId) throws SQLException {
        String sql = "SELECT MAX(re_step) FROM board WHERE ref = ?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, parentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // pdateRef 메서드
    public void updateRef(int parentId, int ref) {
        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement("UPDATE board SET ref = ? WHERE num = ?")) {
            pstmt.setInt(1, ref);
            pstmt.setInt(2, parentId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    //삭제 기능(답글이 존재하면 삭제 불가)
    public int delete(int num) {
        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement("SELECT COUNT(*) FROM board WHERE ref = ?")) {
            pstmt.setInt(1, num);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    if (count > 0) {
                        // 해당 게시글에 답글이 있는 경우 삭제 불가능
                        return 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
            return 0; // 예외 발생 시 삭제 실패로 처리
        }
        
        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement("DELETE FROM board WHERE num = ?")) {
            pstmt.setInt(1, num);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
        }
        return 0;
    }
    
    // 업데이트
    public int update(int num, String subject, String content) {
        try (Connection con = getConnection();
             PreparedStatement pstmt = con.prepareStatement("UPDATE board SET subject = ?, content = ? WHERE num = ?")) {
            pstmt.setString(1, subject);
            pstmt.setString(2, content);
            pstmt.setInt(3, num);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // 로깅
        }
        return 0; // 업데이트 실패 시 0 반환
    }

}
