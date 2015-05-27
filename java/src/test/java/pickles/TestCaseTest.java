package pickles;

import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static java.util.Collections.singletonList;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertSame;

public class TestCaseTest {

    @Test
    public void creates_a_copy_with_different_steps() {
        TestCase glenfarclas = new TestCase("Glenfarclas", new ArrayList<TestStep>(), new ArrayList<Tag>());
        TestStep newStep = new TestStep("new one", null);
        List<TestStep> newSteps = singletonList(newStep);
        TestCase newTestCase = glenfarclas.withTestSteps(newSteps);
        assertSame(newStep, newTestCase.getSteps().get(0));
        assertEquals(glenfarclas.getName(), newTestCase.getName());
    }

    // Then there is steps:
    // withAction....
}