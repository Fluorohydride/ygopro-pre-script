--Battle Royal Mode－Joining
--
--Script by Trishula9
function c100287036.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100287036.target)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c100287036.indtg)
	e2:SetCountLimit(2)
	e2:SetValue(c100287036.indct)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c100287036.rccon)
	e3:SetOperation(c100287036.rcop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c100287036.spcon)
	e4:SetOperation(c100287036.spop)
	c:RegisterEffect(e4)
end
function c100287036.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c100287036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100287036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100287036.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100287036.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
end
function c100287036.indtg(e,c)
	return c==e:GetLabelObject():GetLabelObject()
end
function c100287036.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c100287036.rccon(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsInGroup(e:GetLabelObject():GetLabelObject(),eg)
end
function c100287036.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(1-rp,2000,REASON_EFFECT)
end
function c100287036.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=Duel.GetTurnPlayer()
end
function c100287036.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100287036.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(ep,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c100287036.spfilter,ep,LOCATION_HAND+LOCATION_DECK,0,nil,e,ep)
	if g:GetCount()>0 and Duel.SelectYesNo(ep,aux.Stringid(100287036,0)) then
		Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_SPSUMMON)
		local sc=g:Select(ep,1,1,nil)
		if Duel.SpecialSummon(sc,0,ep,ep,false,false,POS_FACEUP)>0 then
			Duel.SetLP(ep,Duel.GetLP(ep)-2000)
		end
	end
end