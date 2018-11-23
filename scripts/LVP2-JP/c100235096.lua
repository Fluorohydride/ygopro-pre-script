--魔弾の射手 マックス

--Script by nekrozar
function c100235096.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c100235096.matfilter,1,1)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100235096)
	e1:SetCondition(c100235096.effcon)
	e1:SetTarget(c100235096.efftg)
	e1:SetOperation(c100235096.effop)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x108))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
end
function c100235096.matfilter(c)
	return c:IsLevelBelow(8) and c:IsLinkSetCard(0x108)
end
function c100235096.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c100235096.thfilter(c)
	return c:IsSetCard(0x108) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100235096.spfilter(c,e,tp)
	return c:IsSetCard(0x108) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100235096.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100235096.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)>0
		and Duel.IsExistingMatchingCard(c100235096.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(100235096,0),aux.Stringid(100235096,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(100235096,0))
	else op=Duel.SelectOption(tp,aux.Stringid(100235096,1))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(100235096,0))
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(100235096,1))
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function c100235096.effop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(c100235096.thfilter,tp,LOCATION_DECK,0,nil)
		if ct<=0 or g:GetCount()==0 then return end
		local sg=Group.CreateGroup()
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg1=g:Select(tp,1,1,nil)
			local tc=sg1:GetFirst()
			sg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
			ct=ct-1
		until ct<=0 or g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(100235096,2))
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
		local g=Duel.GetMatchingGroup(c100235096.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if ft<=0 or ct<=0 or g:GetCount()==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			g:Remove(Card.IsCode,nil,tc:GetCode())
			ft=ft-1
			ct=ct-1
		until ft<=0 or ct<=0 or g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(100235096,3))
		Duel.SpecialSummonComplete()
	end
end
