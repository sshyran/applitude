package org.applause.applausedsl.scoping;

import static org.eclipse.xtext.scoping.Scopes.scopedElementsFor;

import org.applause.applausedsl.applauseDsl.Entity;
import org.applause.applausedsl.applauseDsl.ObjectReference;
import org.applause.applausedsl.applauseDsl.TypeReference;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.scoping.impl.AbstractScope;

import com.google.common.collect.Iterables;

public class ObjectReferenceScope extends AbstractScope {

	private final ObjectReference container;

	public ObjectReferenceScope(ObjectReference container) {
		this.container = container;
	}

	public IScope getOuterScope() {
		return IScope.NULLSCOPE;
	}

	@Override
	protected Iterable<IEObjectDescription> internalGetContents() {
		TypeReference outerType = TypeUtil.getTypeOf(container.getObject());
		if (outerType != null && outerType.getType() instanceof Entity) {
			Entity entity = (Entity) outerType.getType();
			return scopedElementsFor(entity.getProperties());
		} else
			return Iterables.emptyIterable();
	}

}
