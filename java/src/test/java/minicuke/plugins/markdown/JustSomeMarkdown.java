package minicuke.plugins.markdown;

import com.github.rjeschke.txtmark.Processor;

public class JustSomeMarkdown {
    public static void main(String[] args) {
        String md = "Configuration\n" +
                "=============\n" +
                "\n" +
                "The Admin user should be able to switch permissions for other users.\n" +
                "\n" +
                "Admin Login\n" +
                "-----------\n" +
                "* User must login as \"admin\"\n" +
                "* Navigate to the configuration page\n" +
                "* Change permissions for user \"john\" to \"admin\"\n" +
                "* User \"john\" should have admin permissions";

        String result = Processor.process(md);
        System.out.println(result);
    }
}
