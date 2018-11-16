--サラマングレイト・レイジ
--Salamangreat Rage
--Script by nekrozar
function c100335032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,100335032+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100335032.target)
	e1:SetOperation(c100335032.activate)
	c:RegisterEffect(e1)
end
function c100335032.costfilter(c,mc,tp)
	return c:IsSetCard(0x119) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,Group.FromCards(c,mc))
end
function c100335032.filter(c)
	if not c:IsSummonType(SUMMON_TYPE_LINK) then return false end
	local mat=c:GetMaterial()
	return c:IsFaceup() and c:IsSetCard(0x119) and mat:IsExists(Card.IsLinkCode,1,nil,c:GetCode())
end
function c100335032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	local b1=Duel.IsExistingMatchingCard(c100335032.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e:GetHandler(),tp)
	local b2=Duel.IsExistingTarget(c100335032.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100335032,0),aux.Stringid(100335032,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100335032,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100335032,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100335032.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e:GetHandler(),tp)
		Duel.SendtoGrave(g,REASON_COST)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c100335032.filter,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetProperty(0)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c100335032.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	else
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,tc:GetLink(),nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
