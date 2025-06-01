package domain;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ImageUploadUtil {
    public static List<String> saveImages(List<Part> fileParts, String uploadDirAbsolutePath) throws IOException {
        List<String> savedFileNames = new ArrayList<>();
        File uploadDir = new File(uploadDirAbsolutePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        for (Part filePart : fileParts) {
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (originalFileName != null && !originalFileName.trim().isEmpty()) {
                    String fileExtension = "";
                    int i = originalFileName.lastIndexOf('.');
                    if (i > 0) {
                        fileExtension = originalFileName.substring(i);
                    }
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                    try (InputStream fileContentStream = filePart.getInputStream()) {
                        Files.copy(fileContentStream, Paths.get(uploadDirAbsolutePath + File.separator + uniqueFileName), StandardCopyOption.REPLACE_EXISTING);
                        savedFileNames.add(uniqueFileName);
                    }
                }
            }
        }
        return savedFileNames;
    }

    public static void deleteImage(String fileName, String uploadDirAbsolutePath) {
        if (fileName == null || fileName.isEmpty()) {
            return;
        }
        File imageFile = new File(uploadDirAbsolutePath + File.separator + fileName);
        if (imageFile.exists()) {
            imageFile.delete();
        }
    }

    public static void deleteImages(List<String> fileNames, String uploadDirAbsolutePath) {
        if (fileNames == null) {
            return;
        }
        for (String fileName : fileNames) {
            deleteImage(fileName, uploadDirAbsolutePath);
        }
    }
}