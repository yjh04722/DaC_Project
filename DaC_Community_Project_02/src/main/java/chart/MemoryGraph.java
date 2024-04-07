package chart;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.general.PieDataset;

public class MemoryGraph {
    public static JFreeChart createChart(long usedMemory, long totalMemory) {
        PieDataset dataset = createDataset(usedMemory, totalMemory);
        
        JFreeChart chart = ChartFactory.createPieChart(
                "Memory Usage",  // 차트 제목
                dataset,        // PieDataset 사용
                true,           // 범례 포함
                true,
                false);

        return chart;
    }
    
    private static PieDataset createDataset(long usedMemory, long totalMemory) {
        DefaultPieDataset dataset = new DefaultPieDataset();
        dataset.setValue("Used Memory", usedMemory);
        dataset.setValue("Free Memory", totalMemory - usedMemory);
        return dataset;
    }
}
