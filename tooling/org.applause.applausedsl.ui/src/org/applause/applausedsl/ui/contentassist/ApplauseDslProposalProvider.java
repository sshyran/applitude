/*
 * generated by Xtext
 */
package org.applause.applausedsl.ui.contentassist;

import org.apache.log4j.Logger;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.Path;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.jface.text.contentassist.ICompletionProposal;
import org.eclipse.xtext.RuleCall;
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext;
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor;

/**
 * @see http://www.eclipse.org/Xtext/documentation/latest/xtext.html#contentAssist
 */
public class ApplauseDslProposalProvider extends AbstractApplauseDslProposalProvider {

	private final static Logger log = Logger.getLogger(ApplauseDslProposalProvider.class);

	@Override
	public void complete_ImageExpression(EObject model, RuleCall ruleCall, ContentAssistContext context,
			ICompletionProposalAcceptor acceptor) {
		Resource res = model.eResource();
		URI uri = res.getURI().appendSegment("..").appendSegment("Images");

		String platformResourceString = uri.toPlatformString(true);
		IFolder folder = ResourcesPlugin.getWorkspace().getRoot().getFolder(new Path(platformResourceString));
		try {
			IResource[] members = folder.members();
			for (IResource member : members) {
				String proposal = getValueConverter().toString(member.getName(), "STRING");
				ICompletionProposal completionProposal = createCompletionProposal(proposal, context);
				acceptor.accept(completionProposal);
			}
		} catch (CoreException e) {
			log.error(e.getMessage(), e);
		}
	}
}