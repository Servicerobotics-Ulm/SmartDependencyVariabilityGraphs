Behavior KB { 
	
	KBIsAGroupCollection {  
		
		KBIsAGroup robot { 
			name isKey true,
			"current-room" isKey false,
			goalid isKey false,
			currentSymbolicPosition isKey false,
			"velocity-travelling" isKey false,
			position isKey false
		},
		
		KBIsAGroup location { 
			name isKey true,
			speech isKey false,
			approachType isKey false, 
			"approach-region-pose" isKey false,
			"approach-region-dist" isKey false,
			approachExactPose isKey false,
			approachExactDist isKey false,
			approachExactSafetyCl isKey false,
			orientationRegion isKey false,
			orientationExact isKey false, 
			backwardDist isKey false  
		},
		
		KBIsAGroup counter {  
			name isKey true,
			count isKey false
		},
		
		KBIsAGroup room {
			name isKey true,
			size isKey false,
			offset isKey false
		},
		
		KBIsAGroup station { 
			id isKey true,
			type isKey false,
			"approach-location" isKey false   
		}		 
	}
	
	InitialKnowledge {
		KBUpdate { 
			is-a = "KB.robot",
			"KB.robot.name" = <"1">,
			"KB.robot.velocity-travelling" = <"((0 500)(-60 60))">
			with-keys (is-a, "KB.robot.name")
		}
	} 
}