Behavior ProvideFunctions {        
	
	Function NAME GetFromStationLocation (stationId ("Transportation.DeliverFromToMpsStation.fetchStationId")) provides "Transportation.INITFetchStation.FetchStation" { 
		actions {
			Define {
				station = <KBQuery { is-a "KB.station" "KB.station.id" = <$stationId> }>
				stationType = <GetValue(<$station>, "KB.station.type")>
				stationApproachLocation = <GetValue(<$station>, "KB.station.approach-location")>
				location = <GetValue (<KBQuery { is-a "KB.location" "KB.location.name" = <$stationApproachLocation> }>, "KB.location.approach-region-pose")>
				
				actions {
					"(setf result" $location ")" 
				}
			}	 
		}	
	}     
	 
	Function NAME GetToStationLocation (stationId ("Transportation.DeliverFromToMpsStation.deliverStationId")) provides "Transportation.INITDeliverStation.DeliverStation" { 
		actions {
			Define {
				station = <KBQuery { is-a "KB.station" "KB.station.id" = <$stationId> }>
				stationType = <GetValue(<$station>, "KB.station.type")>
				stationApproachLocation = <GetValue(<$station>, "KB.station.approach-location")>
				location = <GetValue (<KBQuery { is-a "KB.location" "KB.location.name" = <$stationApproachLocation> }>, "KB.location.approach-region-pose")>
				
				actions {
					"(setf result" $location ")" 
				}
			}	 
		}	
	}
	
	TCB NAME GetCurrentRobotPosition provides "Transportation.INITStartPosition.StartPosition" {
		actions {
			push-plan ("BASE".getBasePose <"=> ?x ?y ?yaw">,
						WriteCurrentRobotPositionToKB <"?x ?y ?yaw">
			)
		}
	}
	
	TCB IGNORE getBasePose [getBasePose] (xp, yp, yawp) {
		 
	} 	
	
	TCB NAME WriteCurrentRobotPositionToKB (xp, yp, yawp) {   
		actions {
			"(setf pos (list " $xp $yp $yawp "))"
			KBUpdate { 
				is-a = "KB.robot",
				"KB.robot.position" = <",pos">
				with-keys (is-a)
			}
		}
	}
	
	Function NAME GetCurrentRobotPositionFromKB provides "Transportation.INITStartPosition.StartPosition" {
		actions {
			GetValue (<KBQuery { is-a "KB.robot" }>, "KB.robot.position")
		}
	}   
		  
	TCB IGNORE getBasePose [getBasePose] (xp, yp, yawp) {
		 
	} 	
}