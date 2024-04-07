package chart;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.general.PieDataset;

public class CPUGraph {
    public static JFreeChart createChart(double cpuLoad) {
        // CPU 사용량을 기반으로 한 단순한 파이 차트 생성
        PieDataset dataset = createDataset(cpuLoad);
        
        JFreeChart chart = ChartFactory.createPieChart(
                "CPU Usage",  
                dataset,      
                true,         
                true,
                false);

        return chart;
    }
    
    private static PieDataset createDataset(double cpuLoad) {
        DefaultPieDataset dataset = new DefaultPieDataset();
        dataset.setValue("CPU Usage", cpuLoad);
        return dataset;
    }
}
