package gherkin;

import org.junit.Test;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

import static org.junit.Assert.assertTrue;

/**
 * This is not *really* a test - we're just generating target/good/*.feature.tokens files.
 * No comparisons are made here.
 * <p/>
 * The comparisons are done afterwards with /compare.rb
 * <p/>
 * The only reason this is a JUnit test is to make it easier to run.
 */
public class TokenPrinterTest {
    @Test
    public void prints_tokens_for_all_features() throws IOException {
        File pwd = new File(System.getProperty("user.dir"));
        File projectRoot = findProjectRoot(pwd);

        File good = new File(new File(projectRoot, "testdata"), "good");
        File[] featureFiles = good.listFiles(new FileFilter() {
            @Override
            public boolean accept(File pathname) {
                return pathname.isFile() && pathname.getName().endsWith(".feature");
            }
        });
        File goodOut = new File(new File(new File(projectRoot, "java"), "target"), "good");
        deleteDirectory(goodOut);
        assertTrue(goodOut.mkdirs());
        for (File featureFile : featureFiles) {
            BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(goodOut, featureFile.getName() + ".tokens")), "UTF-8"));
            TokenScanner scanner = new TokenScanner(new InputStreamReader(new FileInputStream(featureFile), "UTF-8"));
            Token token;
            while (true) {
                token = scanner.read();
                out.write(token.toString());
                out.newLine();
                if (token.matchEof()) {
                    out.close();
                    break;
                }
            }
        }
    }

    private File findProjectRoot(File dir) {
        while (true) {
            File testdata = new File(dir, "testdata");
            if (testdata.isDirectory()) {
                break;
            }
            dir = dir.getParentFile();
        }
        return dir;
    }

    public static boolean deleteDirectory(File directory) {
        if (directory.exists()) {
            File[] files = directory.listFiles();
            if (null != files) {
                for (File file : files) {
                    if (file.isDirectory()) {
                        deleteDirectory(file);
                    } else {
                        file.delete();
                    }
                }
            }
        }
        return (directory.delete());
    }
}
