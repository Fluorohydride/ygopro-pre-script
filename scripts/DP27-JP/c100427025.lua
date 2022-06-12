--墓守の罠
--
--Script by Trishula9
function c100427025.initial_effect(c)
	aux.AddCodeList(c,17484499)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c100427025.actcon)
	e1:SetValue(c100427025.aclimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c100427025.actcon)
	e2:SetTarget(c100427025.sumlimit)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,100427025)
	e3:SetCondition(c100427025.thcon)
	e3:SetCost(c100427025.thcost)
	e3:SetTarget(c100427025.thtg)
	e3:SetOperation(c100427025.thop)
	c:RegisterEffect(e3)
	--confirm deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PREDRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,100427025+100)
	e4:SetCondition(c100427025.cfcon)
	e4:SetTarget(c100427025.cftg)
	e4:SetOperation(c100427025.cfop)
	c:RegisterEffect(e4)
end
function c100427025.actcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,17484499)
end
function c100427025.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c100427025.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c100427025.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100427025.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c100427025.thfilter(c)
	return (c:IsSetCard(0x2e) and c:IsType(TYPE_MONSTER) or c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_EARTH))
		and c:IsAbleToHand()
end
function c100427025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100427025.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100427025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100427025.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100427025.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(1-tp)>0 and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c100427025.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c100427025.cfop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetLabel(ac)
	e1:SetOperation(c100427025.disop)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,tp)
end
function c100427025.disop(e,tp,eg,ep,ev,re,r,rp)
	if r~=REASON_RULE then return end
	Duel.ConfirmCards(tp,eg)
	local g=eg:Filter(Card.IsCode,nil,e:GetLabel())
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
end
