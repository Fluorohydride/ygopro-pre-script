--ベアルクティ・クィントチャージ

--Scripted by mallu11
function c100416039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand/spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c100416039.cost)
	e2:SetTarget(c100416039.target)
	e2:SetOperation(c100416039.activate)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100416039,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c100416039.tdcon)
	e3:SetTarget(c100416039.tdtg)
	e3:SetOperation(c100416039.tdop)
	c:RegisterEffect(e3)
end
function c100416039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function c100416039.thfilter(c)
	return c:IsSetCard(0x261) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100416039.rfilter(c,tp)
	return (c:IsFaceup() or c:IsControler(tp)) and c:IsLevelAbove(1) and c:IsSetCard(0x261)
end
function c100416039.mnfilter(c,g,lv)
	return g:IsExists(c100416039.mnfilter2,1,c,c,lv)
end
function c100416039.mnfilter2(c,mc,lv)
	return c:GetLevel()-mc:GetLevel()==lv
end
function c100416039.spfilter(c,e,tp,g,lv)
	return c:IsSetCard(0x261) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
		and (not g and c:IsLevel(lv) or g:IsExists(c100416039.mnfilter,1,nil,g,c:GetLevel()))
end
function c100416039.fselect(g,e,tp)
	return g:GetCount()==2 and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c100416039.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c100416039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100416039.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	local g=Duel.GetReleaseGroup(tp):Filter(c100416039.rfilter,nil,tp)
	local b2=g:CheckSubGroup(c100416039.fselect,2,2,e,tp)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100416039,0))
	elseif not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100416039,1))+1
	elseif b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100416039,0),aux.Stringid(100416039,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function c100416039.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100416039.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if e:GetLabel()==1 then
		local g=Duel.GetReleaseGroup(tp):Filter(c100416039.rfilter,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g:SelectSubGroup(tp,c100416039.fselect,false,2,2,e,tp)
		if rg and rg:GetCount()==2 then
			local c1=rg:GetFirst()
			local c2=rg:GetNext()
			if Duel.Release(rg,REASON_EFFECT)==2 then
				local lv=c1:GetLevel()-c2:GetLevel()
				if lv<0 then lv=-lv end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,c100416039.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil,lv)
				if sg:GetCount()>0 then
					Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
				end
			end
		end
	end
end
function c100416039.cfilter(c,tp)
	return c:IsPreviousSetCard(0x261) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousTypeOnField()&TYPE_SYNCHRO~=0 and c:IsPreviousControler(tp)
end
function c100416039.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100416039.cfilter,1,nil,tp) and Duel.GetAttacker():IsControler(1-tp)
end
function c100416039.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>=7 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,7,0,0)
end
function c100416039.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToDeck),tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local sg=g:Select(1-tp,7,7,nil)
	if sg and sg:GetCount()==7 then
		Duel.SendtoDeck(sg,nil,2,REASON_RULE)
	end
end
