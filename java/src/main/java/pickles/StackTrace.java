package pickles;

import java.util.List;

public class StackTrace {
    static StackTraceElement[] create(List<PickleLocation> source, Uri uri) {
        StackTraceElement[] frames = new StackTraceElement[source.size()];
        int i = 0;
        for (PickleLocation pickleLocation : source) {
            frames[i++] = uri.createStackTraceElement(pickleLocation);
        }
        return frames;
    }
}
