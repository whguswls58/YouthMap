package com.example.demo.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.URLEncoder;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletResponse;

@Controller
public class FileDownloadController {

    @GetMapping("/filedownload")
    public void fileDownload(@RequestParam("filename") String filename,
                             @RequestParam("origin") String origin,
                             HttpServletResponse response) throws Exception {

        // 저장된 파일 경로
        String savePath = "C:/upload/" + filename;
        File file = new File(savePath);

        if (file.exists()) {
            response.setContentType("application/octet-stream");
            String encoded = URLEncoder.encode(origin, "UTF-8").replaceAll("\\+", "%20");
            response.setHeader("Content-Disposition", "attachment;filename=" + encoded);
            response.setContentLength((int) file.length());

            FileInputStream in = new FileInputStream(file);
            OutputStream out = response.getOutputStream();

            byte[] buffer = new byte[1024];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }

            in.close();
            out.close();
        }
    }
}