package egovframework.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EntityScan(basePackages = {
	    "egovframework.example.entity",
	    "egovframework.example.model"
	})  // 엔티티 스캔
@ComponentScan(basePackages = "egovframework.example")  // 서비스 스캔 범위 지정
@EnableScheduling
public class EgovBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(EgovBootApplication.class, args);
	}
}