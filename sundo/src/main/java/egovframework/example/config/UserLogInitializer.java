package egovframework.example.config;

import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import egovframework.example.repository.UserActionLogRepository;

@Component
public class UserLogInitializer implements ApplicationRunner {

    private final UserActionLogRepository userActionLogRepository;

    public UserLogInitializer(UserActionLogRepository userActionLogRepository) {
        this.userActionLogRepository = userActionLogRepository;
    }

    @Override
    public void run(ApplicationArguments args) {
        userActionLogRepository.deleteAll();
        System.out.println("✅ [초기화] user_action_log 테이블 비움");
    }

}
