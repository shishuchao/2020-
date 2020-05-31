package ssc.testCase;

import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import ssc.base.DriverBase;
import ssc.business.*;

import java.util.concurrent.TimeUnit;

/**
 *
 */
public class Login extends CaseBase {

    public DriverBase driver;
    public HomePagePro homePagePro;
    public LoginPro loginpro;
    public CoursePagePro coursePagePro;
    public OrderPayPagePro orderPayPagePro;
    public CourseListPagePro courseListPagePro;
    public SureOrderPagePro sureOrderPagePro;

    /**
     *
     */
    @BeforeClass
    public void testLogin(){
        this.driver = initdriver();
        driver.driver.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
        loginpro = new LoginPro(driver);
        homePagePro = new HomePagePro(driver);
        coursePagePro = new CoursePagePro(driver);
        courseListPagePro = new CourseListPagePro(driver);
        orderPayPagePro = new OrderPayPagePro(driver);
        sureOrderPagePro = new SureOrderPagePro(driver);

    }

    /**
     *
     */
    @Test
    public void testLoginHome(){
        driver.get("http://coding.imooc.com/");
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        homePagePro.clickLoginButton();
    }

    /**
     *
     */
    @AfterClass
    public void test2(){
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        driver.close();
    }
}
