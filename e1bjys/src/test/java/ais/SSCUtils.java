package ais;

import com.sun.javafx.scene.control.skin.TableColumnHeader;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.*;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * @auchor 19381
 */
public class SSCUtils {
    WebDriver driver ;

    public SSCUtils(WebDriver driver1){
        this.driver = driver1;

    }

    /**
     *  DateWidget
     */
    public void dateWidget(List<WebElement> divs,int index){
        List<WebElement> as= divs.get(index).findElements(By.tagName("a"));
        for(WebElement a : as ){
            if(a.getText().equals("今天")){
                a.click();
                break;
            }

        }
    }
    /**
     *  imgs
     */

    /**
     * screenshoot
     */
    public void screenShot(String fileName) throws IOException {
        // 通过TakesScreenshot创建File实例
        File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
        // 创建路径：时间+方法名
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss");
        String filePath = sdf.format(date)+ "-"+fileName +".png";
        System.out.println("                    "+filePath);
        System.out.println();
        // 创建文件  System.getProperty("user.dir")
        FileUtils.copyFile(screenshot,new File(System.getProperty("user.dir")+"\\"+filePath));
        /*
        获取正在执行的方法
        new Object(){}.getClass().getEnclosingMethod().getName();
        Thread.currentThread().getStackTrace()
         */

        /*
         java.version          Java 运行时环境版本
         java.vendor         Java 运行时环境供应商
         java.vendor.url         Java 供应商的 URL
         java.vm.specification.version         Java 虚拟机规范版本
         java.vm.specification.vendor         Java 虚拟机规范供应商
         java.vm.specification.name         Java 虚拟机规范名称
         java.vm.version         Java 虚拟机实现版本
         java.vm.vendor         Java 虚拟机实现供应商
         java.vm.name         Java 虚拟机实现名称
         java.specification.version         Java 运行时环境规范版本
         java.specification.vendor         Java 运行时环境规范供应商
         java.specification.name         Java 运行时环境规范名称
         os.name         操作系统的名称
         os.arch         操作系统的架构
         os.version         操作系统的版本
         file.separator         文件分隔符（在 UNIX 系统中是“ / ”）
         path.separator         路径分隔符（在 UNIX 系统中是“ : ”）
         line.separator         行分隔符（在 UNIX 系统中是“ /n ”）

         java.home         Java 安装目录
         java.class.version         Java 类格式版本号
         java.class.path         Java 类路径
         java.library.path          加载库时搜索的路径列表
         java.io.tmpdir         默认的临时文件路径
         java.compiler         要使用的 JIT 编译器的名称
         java.ext.dirs         一个或多个扩展目录的路径
         user.name         用户的账户名称
         user.home         用户的主目录
         user.dir

         */
    }

}
