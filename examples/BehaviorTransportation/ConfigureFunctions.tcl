Behavior ConfigureFunctions {   
	TCB NAME [NavigationModule] setVelocity (externalValue) configures "BBRepo.GotoLocation.Velocity" for "Transportation.MoveRobot_ApproachRegion" callPrefix Navigation {
		actions {
			Param { server "cdl" slot "CommNavigationObjects.CdlParameter.TRANSVEL" value <"`(0"$externalValue")">}
			Param { server "cdl" slot "COMMIT"}
		}
	}	
}