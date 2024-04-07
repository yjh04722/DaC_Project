<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/include/adminHeader.jsp" %>
<%@ page import="org.jfree.chart.ChartPanel" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.util.Base64" %>
<%@ page import="chart.CPUGraph" %>
<%@ page import="chart.MemoryGraph" %>
<%@ page import="java.awt.*" %>
<%@ page import="javax.swing.*" %>
<%@ page import="org.jfree.chart.*" %>
<%@ page import="org.jfree.data.general.*" %>
<%@ page import="org.jfree.chart.plot.*" %>
<%@ page import="java.awt.Font" %>
<%@ page import="java.awt.GradientPaint" %>
<%@ page import="java.awt.Color" %>
<%@ page import="org.jfree.chart.title.TextTitle" %>
<%@ page import="org.jfree.ui.HorizontalAlignment" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="org.jfree.chart.ChartFactory" %>
<%@ page import="java.awt.geom.Rectangle2D" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.jfree.chart.ChartPanel" %>
<%@ page import="oshi.SystemInfo" %>
<%@ page import="oshi.hardware.CentralProcessor" %>

<%
SystemInfo systemInfo = new SystemInfo();
CentralProcessor processor = systemInfo.getHardware().getProcessor();
double cpuLoad = 0.0;

if (processor != null) {
    // 시간 간격을 1000 밀리초 (1초)로 설정하여 CPU 부하를 가져옵니다.
    long delay = 6000;
    cpuLoad = processor.getSystemCpuLoad(delay);
}

Runtime runtime = Runtime.getRuntime();
long usedMemory = runtime.totalMemory() - runtime.freeMemory();
long totalMemory = runtime.totalMemory();

CPUGraph CPUGraph = new CPUGraph();
MemoryGraph MemoryGraph = new MemoryGraph();

JFreeChart cpuChart = CPUGraph.createChart(cpuLoad);
JFreeChart memoryChart = MemoryGraph.createChart(usedMemory, totalMemory);

// CPU 그래프 이미지 생성
BufferedImage cpuImage = new BufferedImage(400, 300, BufferedImage.TYPE_INT_RGB);
Graphics2D cpuGraphics = cpuImage.createGraphics();
cpuChart.draw(cpuGraphics, new Rectangle2D.Double(0, 0, 400, 300));
ByteArrayOutputStream cpuOutputStream = new ByteArrayOutputStream();
ImageIO.write(cpuImage, "png", cpuOutputStream);
String cpuImageBase64 = Base64.getEncoder().encodeToString(cpuOutputStream.toByteArray());

// 메모리 그래프 이미지 생성
BufferedImage memoryImage = new BufferedImage(400, 300, BufferedImage.TYPE_INT_RGB);
Graphics2D memoryGraphics = memoryImage.createGraphics();
memoryChart.draw(memoryGraphics, new Rectangle2D.Double(0, 0, 400, 300));
ByteArrayOutputStream memoryOutputStream = new ByteArrayOutputStream();
ImageIO.write(memoryImage, "png", memoryOutputStream);
String memoryImageBase64 = Base64.getEncoder().encodeToString(memoryOutputStream.toByteArray());
%>

<html>
<head>
    <style>
        .metabase-dashboard {
            float: right;
        }

        .dashboard {
            width: 900px;
            height: 800px;
        }
        .server-status {
        	margin-left: 150px;
        }
    </style>
</head>
<body>
<div class="content">
    <div class="container_admin">
        <div class="metabase-dashboard">
            <h1 style="padding-left: 360px">접속자 통계</h1>
            <iframe class="dashboard"
                    src="http://localhost:3000/public/question/0986ca11-cf39-4e87-9314-ad659c3ced02"
                    frameborder="0"
                    allowtransparency>
            </iframe>
        </div>
        <div class="server-status">
            <h1>서버 CPU & Memory 사용량</h1>

            <h2>CPU Usage</h2>
            <img src="data:image/png;base64, <%= cpuImageBase64 %>" alt="CPU Usage Chart">

            <h2>Memory Usage</h2>
            <img src="data:image/png;base64, <%= memoryImageBase64 %>" alt="Memory Usage Chart">
        </div>
    </div>
</div>
</body>
</html>
