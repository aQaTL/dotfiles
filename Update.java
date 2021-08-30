import java.util.logging.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.*;
import java.text.MessageFormat;

public class Update {
    static Logger logger = Update.newLogger();

    static Logger newLogger() {
        System.setProperty("java.util.logging.SimpleFormatter.format", "[%1$tT] [%4$s] %5$s %n");
        return Logger.getLogger("");
    }

    public static void main(String[] args) {
        var currentDir = Path.of("").toAbsolutePath();
        logger.log(Level.INFO, "Current dir: {0}", currentDir);

        Os os;
        try {
            os = Os.fromString(System.getProperties().getProperty("os.name"));
        } catch (ParseOsException e) {
            logger.log(Level.SEVERE, "Failed to parse os name: {0}. Defaulting to Linux.", new Object[]{e});
            os = Os.Linux;
        }
        logger.log(Level.INFO, "Running on: {0}", os);

        var configFiles = ConfigFiles.from_os(os);

        logger.log(Level.INFO, "Alacritty filename: {0}", configFiles.getAlacrittyConfigFilename());
        logger.log(Level.INFO, "Alacritty path: {0}",
                java.util.Arrays.stream(configFiles.getAlacrittyConfigPath())
                        .collect(java.util.stream.Collectors.joining("/")));

        try {
            Update.copy(currentDir, configFiles);
        } catch (IOException e) {
            logger.log(Level.SEVERE, "Failed to copy the files: ", e);
        }
    }

    static void copy(Path configDir, ConfigFiles files) throws IOException {
        var sourcePath = configDir.resolve(files.getAlacrittyConfigFilename());
        var targetPath = Path.of(System.getProperties().getProperty("user.home"), files.getAlacrittyConfigPath());
        logger.log(Level.INFO, "Copying {0} into {1}", new Object[]{sourcePath, targetPath});
        Files.copy(sourcePath,
                targetPath,
                StandardCopyOption.REPLACE_EXISTING, StandardCopyOption.COPY_ATTRIBUTES);
    }
}

abstract class ConfigFiles {
    public static ConfigFiles from_os(Os os) {
        return switch (os) {
            case Linux -> new ConfigFilesLinux();
            case Windows -> new ConfigFilesWindows();
            case Mac -> new ConfigFilesMac();
        };
    }

    protected String alacrittyConfigFilename = "alacritty.yml";

    public String getAlacrittyConfigFilename() {
        return this.alacrittyConfigFilename;
    }

    protected String[] alacrittyConfigPath = new String[]{
            ".config",
            "alacritty",
            "alacritty.yml"};

    public String[] getAlacrittyConfigPath() {
        return this.alacrittyConfigPath;
    }
}

class ConfigFilesLinux extends ConfigFiles {
}

class ConfigFilesWindows extends ConfigFiles {
}

class ConfigFilesMac extends ConfigFiles {
    public ConfigFilesMac() {
        super.alacrittyConfigFilename = "alacritty_mac.yml";
    }
}

class ParseOsException extends Exception {
    public ParseOsException(String input) {
        super(MessageFormat.format("{0} is not a known OS string", input));
    }
}

enum Os {
    Linux,
    Windows,
    Mac;

    public static Os fromString(String str) throws ParseOsException {
        switch (str.toLowerCase()) {
            case "linux": {
                return Os.Linux;
            }
            case "windows": {
                return Os.Windows;
            }
            case "mac os x": {
                return Os.Mac;
            }
            default: {
                throw new ParseOsException(str);
            }
        }
    }
}


