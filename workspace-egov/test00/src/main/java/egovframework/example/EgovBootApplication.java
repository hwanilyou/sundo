package egovframework.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "egovframework.example")  // ✅ 이거 추가!
public class EgovBootApplication {

    public static void main(String[] args) {
        SpringApplication.run(EgovBootApplication.class, args);
    }

}
