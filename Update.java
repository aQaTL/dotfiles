import java.util.logging.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.*;

public class Update {
    static Logger logger = Update.newLogger();

    static Logger newLogger() {
        System.setProperty("java.util.logging.SimpleFormatter.format", "[%1$tT] [%4$s] %5$s %n");
        return Logger.getLogger("");
    }

    public static void main(String[] args) {
        var currentDir = Path.of("").toAbsolutePath();
        logger.log(Level.INFO, "Running on: {0}", System.getProperties().getProperty("os.name"));
        logger.log(Level.INFO, "Current dir: {0}", currentDir);

        try {
            Update.copy(currentDir, new ConfigFiles());
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Failed to copy the files: ", e);
        }
    }

    static void copy(Path configDir, ConfigFiles files) throws IOException {
        var sourcePath = configDir.resolve(files.alacrittyConfigFilename);
        var targetPath = Path.of(System.getProperties().getProperty("user.home"), files.alacrittyConfigPath);
        logger.log(Level.INFO, "Copying {0} into {1}", new Object[]{sourcePath, targetPath});
        Files.copy(sourcePath,
                targetPath,
                StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
    }
}

class ConfigFiles {
    public String alacrittyConfigFilename = "alacritty.yml";
    public String[] alacrittyConfigPath = {".config", "alacritty", alacrittyConfigFilename};

}
