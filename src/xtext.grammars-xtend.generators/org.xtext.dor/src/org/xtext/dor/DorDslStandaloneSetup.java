/*
 * generated by Xtext 2.21.0
 */
package org.xtext.dor;


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
public class DorDslStandaloneSetup extends DorDslStandaloneSetupGenerated {

	public static void doSetup() {
		new DorDslStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}
