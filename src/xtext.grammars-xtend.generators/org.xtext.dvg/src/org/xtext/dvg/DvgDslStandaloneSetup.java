/*
 * generated by Xtext 2.21.0
 */
package org.xtext.dvg;


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
public class DvgDslStandaloneSetup extends DvgDslStandaloneSetupGenerated {

	public static void doSetup() {
		new DvgDslStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}