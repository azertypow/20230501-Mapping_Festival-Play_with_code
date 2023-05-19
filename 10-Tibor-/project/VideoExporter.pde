
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

static class VideoExporter
{
  public static String commitPropertiesFile(PApplet applet) {
    ProcessBuilder processBuilder = new ProcessBuilder();
    processBuilder.directory(new File(applet.sketchPath()));
    String gitCommit = "git add properties.json *.pde && git commit -m \"Automated commit\"";
    processBuilder.command("zsh", "-c", gitCommit);

    try {
      Process process = processBuilder.start();

      BufferedReader reader =
        new BufferedReader(new InputStreamReader(process.getInputStream()));

      String acc = "";
      String line;
      while ((line = reader.readLine()) != null) {
        acc += line;
      }

      int exitCode = process.waitFor();
      return acc.strip();
    }
    catch (Exception e) {
      println("Catch all exception");
      println(e);
    }
    return "";
  }


  public static String getLatestGitLog(PApplet applet) {
    ProcessBuilder processBuilder = new ProcessBuilder();
    processBuilder.directory(new File(applet.sketchPath()));
    String gitLog = "git describe --always";
    processBuilder.command("zsh", "-c", gitLog);

    try {
      Process process = processBuilder.start();

      BufferedReader reader =
        new BufferedReader(new InputStreamReader(process.getInputStream()));

      String acc = "";
      String line;
      while ((line = reader.readLine()) != null) {
        acc += line;
      }

      int exitCode = process.waitFor();
      return acc.strip();
    }
    catch (Exception e) {
      println("Catch all exception");
      println(e);
    }
    return "";
  }

  // Git commit + time
  public static String defaultFileName(PApplet applet) {
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("uuuuMMdd-HHmmss");
    LocalDateTime now = LocalDateTime.now();

    return "%s-%s".formatted(dtf.format(now), VideoExporter.getLatestGitLog(applet)).substring(2);
  }

  public static void generateGif(PApplet applet, String fileName) {
    String png2gif = "/usr/local/bin/mogrify -format gif *.png";
    String gifsicle = "/usr/local/bin/gifsicle --delay=2 --loop *.gif > %s.gif".formatted(fileName);
    String saveRes = "mv " + fileName + ".gif temp.bak";
    String rmGif = "rm *.gif";
    String restoreRes = "mv temp.bak " + fileName + ".gif";
    String makeGif = "%s && %s && %s && %s && %s".formatted(png2gif, gifsicle, saveRes, rmGif, restoreRes);

    VideoExporter.executeCommand(applet, makeGif);
  }

  public static void generateVideo(PApplet applet, String fileName) {
    String makeIGLoop = "./encode-for-ig.sh %s".formatted(fileName);
    VideoExporter.executeCommand(applet, makeIGLoop);
  }

  public static void cleanupImages(PApplet applet, String folderName) {
    String cleanup = "mkdir -p %s && mv *.png %s && mv *.wav %s".formatted(folderName, folderName, folderName);
    VideoExporter.executeCommand(applet, cleanup);
    String cleanup2 = "rm *.avi";
    VideoExporter.executeCommand(applet, cleanup2);
  }

  public static void executeCommand(PApplet applet, String command) {
    ProcessBuilder processBuilder = new ProcessBuilder();
    processBuilder.directory(new File(applet.sketchPath()));

    println("Executing command: %s".formatted(command));
    processBuilder.command("zsh", "-c", command);

    try {
      Process process = processBuilder.start();

      BufferedReader reader =
        new BufferedReader(new InputStreamReader(process.getInputStream()));

      String line;
      while ((line = reader.readLine()) != null) {
        System.out.println(line);
      }

      int exitCode = process.waitFor();

      System.out.println("\nExited with code : " + exitCode);
      if (exitCode != 0) {
        println("Failed to generate the documentation.");
      }
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    catch (InterruptedException e) {
      e.printStackTrace();
    }
    catch (Exception e) {
      println("Catch all exception");
      println(e);
    }
  }
}
