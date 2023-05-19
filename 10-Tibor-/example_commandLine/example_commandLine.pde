import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

String getLatestGitLog() {
  ProcessBuilder processBuilder = new ProcessBuilder();
  processBuilder.directory(new File(sketchPath()));
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

void setup() {  
  ProcessBuilder processBuilder = new ProcessBuilder();
  processBuilder.directory(new File(sketchPath()));
  String folderName = "test";
  String fileName = "animation";

  String png2gif = "/usr/local/bin/mogrify -format gif *.png";
  String gifsicle = "/usr/local/bin/gifsicle --delay=2 --loop *.gif > %s.gif".formatted(fileName);
  String saveRes = "mv " + fileName + ".gif temp.bak";
  String rmGif = "rm *.gif";
  String restoreRes = "mv temp.bak " + fileName + ".gif";

  String makeGif = "%s && %s && %s && %s && %s".formatted(png2gif, gifsicle, saveRes, rmGif, restoreRes);
  String makeVideo = "/usr/local/bin/ffmpeg -y -framerate 30 -pattern_type glob -i '*.png' -preset veryslow -tune animation -c:v libx264 -pix_fmt yuv420p -crf 23 -f mp4 %s.mov".formatted(fileName);
  String cleanup = "mkdir -p %s && mv *.png %s".formatted(folderName, folderName);

  String generateDocumentation = "%s && %s && %s".formatted(makeGif, makeVideo, cleanup);
  println(generateDocumentation);

  String gitLog = "git describe --always";

  //processBuilder.command("zsh", "-c", generateDocumentation);

  processBuilder.command("zsh", "-c", gitLog);

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
