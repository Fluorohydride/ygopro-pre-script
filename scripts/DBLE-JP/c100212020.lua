--妖仙獣の神颪
--Yosenju's Divine Mountain Winds
--Scripted by Eerie Code
function c100212020.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100212020.condition)
	e1:SetTarget(c100212020.target)
	e1:SetOperation(c100212020.activate)
	c:RegisterEffect(e1)
end
function c100212020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c100212020.thfilter(c)
	return c:IsSetCard(0xb3) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c100212020.pzfilter(c,cd)
	return c:IsCode(cd) and not c:IsForbidden()
end
function c100212020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100212020.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=(Duel.IsExistingMatchingCard(c100212020.pzfilter,tp,LOCATION_DECK,0,1,nil,65025250)
		and Duel.IsExistingMatchingCard(c100212020.pzfilter,tp,LOCATION_DECK,0,1,nil,91420254)
		and Duel.CheckLocation(tp,LOCATION_SZONE,6) and Duel.CheckLocation(tp,LOCATION_SZONE,7))
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100212020,0),aux.Stringid(100212020,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100212020,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100212020,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function c100212020.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100212020.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100212020.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if not Duel.CheckLocation(tp,LOCATION_SZONE,6) or not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return end
		local g1=Duel.GetMatchingGroup(c100212020.pzfilter,tp,LOCATION_DECK,0,nil,65025250)
		local g2=Duel.GetMatchingGroup(c100212020.pzfilter,tp,LOCATION_DECK,0,nil,91420254)
		if g1:GetCount()==0 or g2:GetCount()==0 then return end
		local tc1=g1:GetFirst()
		local tc2=g2:GetFirst()
		Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local de1=Effect.CreateEffect(c)
		de1:SetCategory(CATEGORY_DESTROY)
		de1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		de1:SetCode(EVENT_PHASE+PHASE_END)
		de1:SetCountLimit(1)
		de1:SetCondition(c100212020.descon)
		de1:SetOperation(c100212020.desop)
		de1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc1:RegisterEffect(de1)
		local de2=de1:Clone()
		tc2:RegisterEffect(de2)
	end
end
function c100212020.splimit(e,c)
	return not c:IsSetCard(0xb3)
end
function c100212020.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100212020.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
