/*
 * generated by Xtext
 */
package org.applause.applausedsl.formatting;

import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter;
import org.eclipse.xtext.formatting.impl.FormattingConfig;

/**
 * This class contains custom formatting description.
 *
 * see : http://www.eclipse.org/Xtext/documentation/latest/xtext.html#formatting
 * on how and when to use it
 *
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
public class ApplauseDslFormatter extends AbstractDeclarativeFormatter {

	@Override
	protected void configureFormatting(FormattingConfig c) {
		org.applause.applausedsl.services.ApplauseDslGrammarAccess f = (org.applause.applausedsl.services.ApplauseDslGrammarAccess) getGrammarAccess();

		c.setLinewrap(0, 1, 2).before(f.getSL_COMMENTRule());
		c.setLinewrap(0, 1, 2).before(f.getML_COMMENTRule());
		c.setLinewrap(0, 1, 1).after(f.getML_COMMENTRule());

		// ...
	}
}
