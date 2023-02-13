Behavior Transportation {      
	
	Import ProvideFunctions
	Import ConfigureFunctions 
	
	ErrorCollection { 
		UnknownLocation = "(ERROR (UNKNOWN LOCATION))",
		RobotBlocked = "(ERROR (ROBOT BLOCKED))"  
	}
	
	TCB NAME DeliverFromToMpsStation (fetchStationId, fetchBeltId, deliverStationId, deliverBeltId)  
		realizes "Transportation.Transportation" 
		RequirementSpecification true  
		{ 
			push-plan (0 : FetchFromMpsStation <$fetchStationId $fetchBeltId>, 
				       1 : DeliverToMpsStation <$deliverStationId $deliverBeltId>
			)
		}
	
	TCB NAME FetchFromMpsStation (stationId, beltId) {
		actions {
			Define {
				station = <KBQuery { is-a "KB.station" "KB.station.id" = <$stationId> }>
				stationType = <GetValue(<$station>, "KB.station.type")>
				stationApproachLocation = <GetValue(<$station>, "KB.station.approach-location")>
				
				actions {
					push-plan (0 : Navigation.MoveRobot_ApproachRegion <$stationApproachLocation> instance 0, 
							   1 : MPS.MpsStationDock <$stationId $beltId>,
							   2 : MPS.MpsStationLoad <$stationId>,
							   3 : MPS.MpsStationUndock 
					)
				}
			}
		}
		
	}
	
	TCB NAME DeliverToMpsStation (stationId, beltId) {
		actions {
			Define {
				station = <KBQuery { is-a "KB.station" "KB.station.id" = <$stationId> }> 
				stationType = <GetValue(<$station>, "KB.station.type")>
				stationApproachLocation = <GetValue(<$station>, "KB.station.approach-location")>
				
				actions {
					push-plan (0 : Navigation.MoveRobot_ApproachRegion <$stationApproachLocation> instance 1,
							   1 : MPS.MpsStationDock <$stationId $beltId>,
							   2 : MPS.MpsStationUnload <$stationId>,
							   3 : MPS.MpsStationUndock
					)
				}
			}
		}		
	}

	TCB NAME [NavigationModule] MoveRobot_ApproachRegion subname ApproachRegion (location) realizes "BBRepo.GotoLocation" {     
		actions { 
			Define {
				pose = <GetValue(<KBQuery { is-a "KB.location" "KB.location.name" = <$location> } >,"KB.location.approach-region-pose")>
				dist = <GetValue(<KBQuery { is-a "KB.location" "KB.location.name" = <$location> } >,"KB.location.approach-region-dist")>
				robotCurrentRoomName = <GetValue(< KBQuery { is-a "KB.robot" } >,"KB.robot.current-room")>
				robotRoom = <KBQuery { is-a "KB.room" "KB.room.name" = <$robotCurrentRoomName> }>
				velocityTravelling = <GetValue(< KBQuery { is-a "KB.robot" } >, "KB.robot.velocity-travelling")> 
				goalid = <"nil">
				
				actions {   
					
						if <"(null" $pose")"> {   
							return UnknownLocation
						}

					   	else {  
							EventActivation { evtName "evt-cdlgoal" server "cdl" service "goalEvent" eventMode CONTINUOUS eventhandler Cdl }	
							EventActivation { evtName "evt-cdlblocked" server "cdl" service "blockedEvent" eventMode CONTINUOUS eventhandler CdlBlocked }
							KBUpdate { 
								is-a = "KB.counter",
							    "KB.counter.name" = <"no-path-counter">,
								"KB.counter.count" = <"0">	   
								with-keys (is-a)        
							}  
							EventActivation { evtName "evt-planner" server "planner" service "plannerEvent" eventMode CONTINUOUS eventhandler PlannerApproachHalt }
							"(setf" $goalid GetValue(<KBQuery { is-a "KB.robot" } >,"KB.robot.goalid")")"
			                "(setf" $goalid "(+" $goalid "1))"
			                "(format t \"GoalID: ~s~%\" "$goalid")"
							KBUpdate {
								is-a = "KB.robot",
								"KB.robot.goalid" = <$goalid>
								with-keys (is-a)
							}
							State { server "planner" state "Neutral" } 
							State { server "mapper" state "Neutral" }
							
							Param { server "cdl" slot "CommNavigationObjects.CdlParameter.ID" value <$goalid>}
							Param { server "cdl" slot "CommNavigationObjects.CdlParameter.LOOKUPTABLE" value <"'DEFAULT">}
					   		Param { server "cdl" slot "CommNavigationObjects.CdlParameter.SAFETYCL" value <"200">}
					   		//Param { server "cdl" slot "CommNavigationObjects.CdlParameter.TRANSVEL" value <"(first" $velocityTravelling")">}
							Param { server "cdl" slot "CommNavigationObjects.CdlParameter.ROTVEL" value <"(second" $velocityTravelling")">}				   		
							Param { server "cdl" slot "CommNavigationObjects.CdlParameter.APPROACHDIST" value <$dist>}
							Param { server "cdl" slot "COMMIT"}
							
							Param { 
									server "mapper" slot "CommNavigationObjects.MapperParams.CURPARAMETER" 
								    value <"(append" GetValue(<$robotRoom>,"KB.room.size") GetValue(<$robotRoom>,"KB.room.offset") "(list" $goalid"))"> 
							}

							Param { server "mapper" slot "CommNavigationObjects.MapperParams.CURLOADLTM" }
							Param { server "mapper" slot "COMMIT" }
							
							Param { server "planner" slot "CommNavigationObjects.PlannerParams.ID" value <$goalid>}
							Param { server "planner" slot "CommNavigationObjects.PlannerParams.DELETEGOAL" }
							Param { server "planner" slot "CommNavigationObjects.PlannerParams.SETDESTINATIONCIRCLE" value <"`(,(first" $pose") ,(second" $pose") ,"$dist")">}
							Param { server "planner" slot "COMMIT" }
							
							State { server "planner" state "PathPlanning" }
							State { server "mapper" state "BuildCurrMap" } 
							
							return Success						   	
					   }					
				} 
			}
		}
	}
	
	EventHandler NAME Cdl { 
		actions {
			if <"(equal (tcl-event-message) \"(reached)\")"> {
				"(format t \"=========================>>> GOAL REACHED !!! ~%\")"
				State { server "cdl" state "Neutral" }
				State { server "mapper" state "Neutral" }
				State { server "planner" state "Neutral" }
				KBUpdate {
					is-a = "KB.robot",
					"KB.robot.currentSymbolicPosition" = <$"MoveRobot_ApproachRegion.location">
					with-keys (is-a)
				}
				Abort
				return Success
			}
		}
	}
	EventHandler NAME CdlBlocked { 
		actions {
			if <"(equal (tcl-event-message) \"(blocked)\")"> {
				"(format t \"=========================>>> ROBOT BLOCKED !!! ~%\")"
				State { server "cdl" state "Neutral" }
				State { server "mapper" state "Neutral" }
				State { server "planner" state "Neutral" }
				Abort
				return RobotBlocked		
			}
		}
	}
	EventHandler NAME PlannerApproachHalt { 
		
		actions {
			
			if <"(equal (tcl-event-message) \"(start occupied by goal)\")"> {
				"(format t \"=========================>>> start occupied by goal !!! ~%\")"
				State { server "mapper" state "Neutral" }
				State { server "planner" state "Neutral" }
            	"(tcl-kb-update :key '(is-a) :value '((is-a robot)(current-symbolic-position ?location)))"
				KBUpdate {
					is-a = "KB.robot",
					"KB.robot.currentSymbolicPosition" = <$"MoveRobot_ApproachRegion.location">
					with-keys (is-a)
				}            		
            	Abort
            	return Success
			}
			
			else-if <"(equal (tcl-event-message) \"(start occupied by obstacle)\")"> {
				"(format t \"=========================>>> start occupied by obstacle !!! ~%\")"
			   	Param { server "mapper" slot "CommNavigationObjects.MapperParams.CURLOADLTM" }	
			}
			
			else-if <"(equal (tcl-event-message) \"(wrong map id)\")"> {
				"(format t \"=========================>>> wrong map id !!! ~%\")"
			} 
			
			else-if <"(equal (tcl-event-message) \"(no path)\")"> { 
				Define {
					counterClass = <KBQuery { is-a "KB.counter" "KB.counter.name" = <"no-path-counter">  }>
					counter = <GetValue(<$counterClass>,"KB.counter.count")> 
					
					actions {
						"(setf counter  (+ counter 1))
            		 	(format t \"=========================>>> no path !!! count: ~a ~%\" counter)
            		 	"
            		 	
						KBUpdate { 
							is-a = "KB.counter",
						    "KB.counter.name" = <"no-path-counter">,
							"KB.counter.count" = <",counter">
							with-keys (is-a)	           
						} 
						
						if <"(<" $counter "3)"> {
							"(format t \"Clean current map! ~%\")"
							Param { server "mapper" slot "CommNavigationObjects.MapperParams.CURLOADLTM" }	
						}
						else {
							State { server "cdl" state "Neutral" }
					   		State { server "purepursuit" state "Neutral" }
					   		State { server "mapper" state "Neutral" }
					   		State { server "planner" state "Deactivated" }
					   		State { server "planner" state "Neutral" }
					   		Abort
					   		return RobotBlocked
						}	
					}
				}	
			}
			
			else-if <"(equal (tcl-event-message) \"(ok)\")"> {
				"(format t \"=========================>>> ok !!! ~%\")"
		   		Param { server "cdl" slot "CommNavigationObjects.CdlParameter.GOALMODE" value <"'PLANNER"> }
				Param { server "cdl" slot "CommNavigationObjects.CdlParameter.LOOKUPTABLE" value <"'DEFAULT"> }
				Param { server "cdl" slot "CommNavigationObjects.CdlParameter.SETSTRATEGY" value <"'APPROACH_HALT"> }			   		
				Param { server "cdl" slot "COMMIT" }
				State { server "cdl" state "MoveRobot" }	
			}
			
			else {
				"(format t \"=========================>>> unsupported event ~s !!! ~%\" *MSG* )"
			}
		}
	}	
	
	TCB NAME [MPSModule] MpsStationDock (stationId, beltId) {
		actions {
			EventActivation { evtName "evtMpsDocking" server "MPSDOCKING" service "dockingevent" eventMode CONTINUOUS eventhandler MpsDocking }
			State { server "MPSDOCKING" state "LaserDocking" }
		}
	}
	
	EventHandler NAME MpsDocking {
		actions {
			if <"(equal (tcl-event-message) \"(laser docking not done)\")"> {
				"(format t \"=========================>>> LASER DOCKING DOCKING START~%\")"	
			}
			else-if <"(equal (tcl-event-message) \"(laser docking done)\")"> {
				"(format t \"=========================>>> LASER DOCKING DOCKING DONE~%\")"
				State { server "MPSDOCKING" state "Neutral" }
				Abort
				return Success
			}
			else-if <"(equal (tcl-event-message) \"(undocking not done)\")"> {
				"(format t \"=========================>>> UNDOCKING DOCKING START~%\")"	
			}
			else-if <"(equal (tcl-event-message) \"(undocking done)\")"> {
				"(format t \"=========================>>> UNDOCKING DOCKING DONE~%\")"	
				State { server "MPSDOCKING" state "Neutral" }
				Abort
				return Success
			}	
		}	
	}
	
	TCB NAME [MPSModule] MpsStationLoad (stationId) {
		actions {
			EventActivation { evtName "evtBeltLoading" server "BELT" service "loadevent" eventMode CONTINUOUS eventhandler MpsLoading }
			Param { server "BELT" slot "COMMROBOTINOOBJECTS.ROBOTINOCONVEYERPARAMETER.SETSTATIONID" value <$stationId> }
			Param { server "BELT" slot "COMMIT" }
			State { server "BELT" state "load" }
		}
	}
	
	EventHandler NAME MpsLoading {
		actions {
			if <"(equal (tcl-event-message) \"(load not done)\")"> {
				"(format t \"=========================>>> load START~%\")"	
			}
			else-if <"(equal (tcl-event-message) \"(load done)\")"> {
				"(format t \"=========================>>> load DONE SUCCESS~%\")"
				State { server "BELT" state "Neutral" }
				DeletePlan
				Abort
				return Success
			}
			else-if <"(equal (tcl-event-message) \"(load error no box)\")"> {
				"(format t \"=========================>>> load DONE ERROR (no box)~%\")"
			}
			else-if <"(equal (tcl-event-message) \"(load error box already present)\")"> {
				"(format t \"=========================>>> load DONE ERROR (box already present)~%\")"				
			}
			else-if <"(equal (tcl-event-message) \"(load error no response from station)\")"> {
				"(format t \"=========================>>> load DONE ERROR (no response from station)~%\")"				
			}	
			else-if <"(equal (tcl-event-message) \"(unload not done)\")"> { 
				"(format t \"=========================>>> unload START~%\")"	
			}
			else-if <"(equal (tcl-event-message) \"(unload done)\")"> { 
				"(format t \"=========================>>> unload DONE SUCCESS~%\")"
				State { server "BELT" state "Neutral" }
				DeletePlan
				Abort
				return Success
			}	
			else-if <"(equal (tcl-event-message) \"(unload error no box)\")"> {
				"(format t \"=========================>>> unload DONE ERROR (no box)~%\")"
			}	
			else-if <"(equal (tcl-event-message) \"(unload error box still present)\")"> {
				"(format t \"=========================>>> unload DONE ERROR (box still present)~%\")"
			}	
			else-if <"(equal (tcl-event-message) \"(unload error no response from station)\")"> {
				"(format t \"=========================>>> unload DONE ERROR (no response from station)~%\")"
			}														
		}		
	}
	
	TCB NAME [MPSModule] MpsStationUnload (stationId) {   
		actions {
			EventActivation { evtName "evtBeltUnloading" server "BELT" service "loadevent" eventMode CONTINUOUS eventhandler MpsLoading }
			Param { server "BELT" slot "COMMROBOTINOOBJECTS.ROBOTINOCONVEYERPARAMETER.SETSTATIONID" value <$stationId> }
			Param { server "BELT" slot "COMMIT" }
			State { server "BELT" state "unload" }	
		}
	}
	 
	TCB NAME [MPSModule] MpsStationUndock {  
		actions {
			EventActivation { evtName "evtMpsDocking" server "MPSDOCKING" service "dockingevent" eventMode CONTINUOUS eventhandler MpsDocking }
			State { server "MPSDOCKING" state "UnDocking" }	
		}
	}
}