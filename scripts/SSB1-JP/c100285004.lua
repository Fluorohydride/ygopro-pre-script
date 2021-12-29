--逢華妖麗譚-魔妖不知火語
--
--Script by Trishula9
function c100285004.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100285004)
	e1:SetCost(c100285004.limcost)
	e1:SetOperation(c100285004.limop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,100285004)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100285004.tgtg)
	e2:SetOperation(c100285004.tgop)
	c:RegisterEffect(e2)
end
function c100285004.rfilter(c,tp)
	return c:IsSetCard(0x121,0xd9) and c:IsType(TYPE_SYNCHRO+TYPE_LINK) and (c:IsControler(tp) or c:IsFaceup())
end
function c100285004.limcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100285004.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c100285004.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c100285004.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c100285004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100285004.splimit(e,c)
	return c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function c100285004.tgfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsFaceup() and c:IsAbleToGrave()
end
function c100285004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c100285004.tgfilter(c) end
	if chk==0 then return Duel.IsExistingTarget(c100285004.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c100285004.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c100285004.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end
