/*
 * generated by Xtext 2.27.0
 */
package org.xtext.dor.ui.tests;

import com.google.inject.Injector;
import org.eclipse.xtext.testing.IInjectorProvider;
import org.xtext.dor.ui.internal.DorActivator;

public class DorDslUiInjectorProvider implements IInjectorProvider {

	@Override
	public Injector getInjector() {
		return DorActivator.getInstance().getInjector("org.xtext.dor.DorDsl");
	}

}
