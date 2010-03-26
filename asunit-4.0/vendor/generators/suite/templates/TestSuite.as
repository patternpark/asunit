package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */
    <% test_case_classes.each do |test_case| %>
    import <%= test_case %>;<% end %>

    [Suite]
	public class AllTests {
        <% test_case_classes.each do |test_case| %>
        public var <%= test_case.gsub('.', '_') %>:<%= test_case %>;<% end %>
	}
}

