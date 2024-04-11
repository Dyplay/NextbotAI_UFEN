using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Playspaces }
 
EnemyDevice := class(creative_device):

    PlayerChar : ?agent = false

    @editable
    var ZOffset : float = 75.0

    @editable
    var Speed : float = 5.0

    @editable
    var EnemyProp : creative_prop = creative_prop{}
 
    @editable
    var ZoneDevice : mutator_zone_device = mutator_zone_device{}

    PropTranslationAxis : vector3 = vector3:
        X := 0.0
        Y := 0.0
        Z := -1.0

    OnBegin<override>()<suspends>:void=
        ZoneDevice.AgentEntersEvent.Subscribe(OnTriggered)
 
    OnTriggered(Agent: agent):void =
        spawn{DoFacePlayer()}
        spawn{FollowPlayer()}
 
    FollowPlayer()<suspends>:void = 
 
        loop:
            Sleep(0.0)
            if (PlayerList := GetPlayspace().GetPlayers(), FortCharacter := PlayerList[0].GetFortCharacter[]):
                PlayerTranslation := FortCharacter.GetTransform().Translation
                PropTranslation := EnemyProp.GetTransform().Translation
 
                VectorToPlayer := PlayerTranslation - PropTranslation
 
                RadiansVectorToPlayer: float = ArcTan(VectorToPlayer.X, VectorToPlayer.Y)
 
                NewRotation : rotation = MakeRotation(Axis := PropTranslationAxis, AngleRadians := RadiansVectorToPlayer)
 
                EnemyProp.MoveTo(PlayerTranslation - vector3{Z:=ZOffset}, NewRotation, Speed)
 
            else:
                 break

    
    DoFacePlayer()<suspends> : void =

        loop:
            Sleep(0.0)
            if (PlayerList := GetPlayspace().GetPlayers(), FortCharacter := PlayerList[0].GetFortCharacter[]):
                PlayerTranslation := FortCharacter.GetTransform().Translation
                PropTranslation := EnemyProp.GetTransform().Translation

                VectorToPlayer := PlayerTranslation - PropTranslation

                RadiansVectorToPlayer := ArcTan(VectorToPlayer.X, VectorToPlayer.Y)

                NewRotation := MakeRotation(Axis := PropTranslationAxis, AngleRadians :=  RadiansVectorToPlayer)

                if (EnemyProp.TeleportTo[Position := PropTranslation, Rotation := NewRotation]) {}