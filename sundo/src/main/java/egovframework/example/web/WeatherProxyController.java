package egovframework.example.web;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/proxy")
public class WeatherProxyController {

    @GetMapping(value = "/station-info", produces = "text/plain;charset=UTF-8")
       public String getStationInfo() throws Exception {
           URL url = new URL("https://apihub.kma.go.kr/api/typ01/url/stn_inf.php?inf=AWS&stn=&tm=202211300900&help=1&authKey=_v7wW5IUQqu-8FuSFNKrLA");
           try (BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(), Charset.forName("EUC-KR")))) {
               return in.lines().collect(Collectors.joining("\n"));
           }
       }

    @GetMapping(value = "/weather-data", produces = "text/plain;charset=UTF-8")
    public String getWeatherData() throws Exception {
        URL url = new URL("https://apihub.kma.go.kr/api/typ01/cgi-bin/url/nph-aws2_min?stn=0&disp=0&help=1&authKey=Qesc6Lz3Tz6rHOi89w8-QQ");

        // https://apihub.kma.go.kr/api/typ01/cgi-bin/url/nph-aws2_min?stn=0&disp=0&help=1&authKey=Qesc6Lz3Tz6rHOi89w8-QQ
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        // ✅ User-Agent 추가 (중요)
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");

        // ✅ 응답 코드 확인 (디버깅용)
        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            throw new Exception("HTTP error code: " + responseCode);
        }

        try (BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), Charset.forName("EUC-KR")))) {
            return in.lines().collect(Collectors.joining("\n"));
        }
    }
    
    @GetMapping("/dam_info")
    public String getDamInfo() throws Exception {
        URL url = new URL("https://api.hrfco.go.kr/52832662-D130-4239-9C5F-730AD3BE6BC6/dam/info.json");
        try (BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(), StandardCharsets.ISO_8859_1))) {
            return in.lines().collect(Collectors.joining("\n"));
        }
    }
    
    @GetMapping("/dam_data")
    public String getDamData() throws Exception {
        URL url = new URL("https://api.hrfco.go.kr/52832662-D130-4239-9C5F-730AD3BE6BC6/dam/list/10M.json");
        try (BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(), StandardCharsets.UTF_8))) {
            return in.lines().collect(Collectors.joining("\n"));
        }
    }
}
