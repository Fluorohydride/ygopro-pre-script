--倶利伽罗天童
function c101109031.initial_effect(c)
	c:EnableReviveLimit()
	if not c101109031.reg then
		c101109031.reg={}
		c101109031.reg[0]={}
		c101109031.reg[1]={}
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_SOLVED)
		e0:SetCondition(c101109031.reccon)
		e0:SetOperation(c101109031.recop)
		Duel.RegisterEffect(e0,0)
	end
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101109031,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c101109031.spcon)
	e2:SetOperation(c101109031.spop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c101109031.atkval)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101109031,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101109031)
	e4:SetCondition(c101109031.sp2con)
	e4:SetTarget(c101109031.sp2tg)
	e4:SetOperation(c101109031.sp2op)
	c:RegisterEffect(e4)
end
function c101109031.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re and (re:GetActivateLocation() & LOCATION_MZONE)>0
end
function c101109031.recop(e,tp,eg,ep,ev,re,r,rp)
	c101109031.reg[rp][re:GetHandler()]=Duel.GetTurnCount()
end
function c101109031.spfilter(c,ft,tp,nocheck)
	return c101109031.reg[1-tp][c]==Duel.GetTurnCount()
		and c:IsFaceup() and Duel.IsPlayerCanRelease(tp,c)
		and (c:IsControler(tp) or ft>0 or nocheck)
end
function c101109031.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	local ft=Duel.GetMZoneCount(tp)
	return Duel.GetMatchingGroupCount(c101109031.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ft,tp,false)>0
end
function c101109031.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c101109031.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ft,tp,true)
	e:GetLabelObject():SetLabel(Duel.Release(g,REASON_COST))
end
function c101109031.atkval(e,c)
	return e:GetLabel()*1500
end
function c101109031.sp2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101109031.sp2filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101109031.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c101109031.sp2filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingTarget(c101109031.sp2filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101109031.sp2filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101109031.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
