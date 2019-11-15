--アクセスコード・トーカー

--Scripted by mallu11
function c101012046.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012046,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101012046.atkcon)
	e1:SetTarget(c101012046.atktg)
	e1:SetOperation(c101012046.atkop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012046,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c101012046.descost)
	e2:SetTarget(c101012046.destg)
	e2:SetOperation(c101012046.desop)
	c:RegisterEffect(e2)
end
function c101012046.atkfilter(c,e)
	return c:IsType(TYPE_LINK) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
		and c:IsCanBeEffectTarget(e)
end
function c101012046.chainlm(e,ep,tp)
	return tp==ep
end
function c101012046.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101012046.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	if chkc then return mg:IsContains(chkc) and c101012046.atkfilter(chkc,e) end
	if chk==0 then return mg:IsExists(c101012046.atkfilter,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=mg:FilterSelect(tp,c101012046.atkfilter,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetChainLimit(c101012046.chainlm)
end
function c101012046.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)  then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetLink()*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c101012046.cfilter(c,tp)
	local att=0
	if Duel.GetFlagEffect(tp,101012046)==0 then
		att=bit.bor(att,ATTRIBUTE_EARTH)
	end
	if Duel.GetFlagEffect(tp,101012146)==0 then
		att=bit.bor(att,ATTRIBUTE_WATER)
	end
	if Duel.GetFlagEffect(tp,101012246)==0 then
		att=bit.bor(att,ATTRIBUTE_FIRE)
	end
	if Duel.GetFlagEffect(tp,101012346)==0 then
		att=bit.bor(att,ATTRIBUTE_WIND)
	end
	if Duel.GetFlagEffect(tp,101012446)==0 then
		att=bit.bor(att,ATTRIBUTE_LIGHT)
	end
	if Duel.GetFlagEffect(tp,101012546)==0 then
		att=bit.bor(att,ATTRIBUTE_DARK)
	end
	if Duel.GetFlagEffect(tp,101012646)==0 then
		att=bit.bor(att,ATTRIBUTE_DIVINE)
	end
	return c:IsType(TYPE_LINK) and c:IsAttribute(att) and c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c101012046.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012046.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101012046.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101012046.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c101012046.chainlm)
end
function c101012046.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	local att=e:GetLabel()
	if bit.band(att,ATTRIBUTE_EARTH)~=0 then
		Duel.RegisterFlagEffect(tp,101012046,RESET_PHASE+PHASE_END,0,1)
	end
	if bit.band(att,ATTRIBUTE_WATER)~=0 then
		Duel.RegisterFlagEffect(tp,101012146,RESET_PHASE+PHASE_END,0,1)
	end
	if bit.band(att,ATTRIBUTE_FIRE)~=0 then
		Duel.RegisterFlagEffect(tp,101012246,RESET_PHASE+PHASE_END,0,1)
	end
	if bit.band(att,ATTRIBUTE_WIND)~=0 then
		Duel.RegisterFlagEffect(tp,101012346,RESET_PHASE+PHASE_END,0,1)
	end
	if bit.band(att,ATTRIBUTE_LIGHT)~=0 then
		Duel.RegisterFlagEffect(tp,101012446,RESET_PHASE+PHASE_END,0,1)
	end
	if bit.band(att,ATTRIBUTE_DARK)~=0 then
		Duel.RegisterFlagEffect(tp,101012546,RESET_PHASE+PHASE_END,0,1)
	end
	if bit.band(att,ATTRIBUTE_DIVINE)~=0 then
		Duel.RegisterFlagEffect(tp,101012646,RESET_PHASE+PHASE_END,0,1)
	end
end
