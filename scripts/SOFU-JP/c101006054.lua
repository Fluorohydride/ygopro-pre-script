--ワールド・ダイナ・レスリング
--World Dino Wrestling
--Script by nekrozar
function c101006054.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c101006054.atklimcon)
	e2:SetTarget(c101006054.atklimtg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c101006054.checkop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c101006054.atkcon)
	e4:SetTarget(c101006054.atktg)
	e4:SetValue(200)
	c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101006054,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,101006054)
	e5:SetCondition(c101006054.spcon)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c101006054.sptg)
	e5:SetOperation(c101006054.spop)
	c:RegisterEffect(e5)
end
function c101006054.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x221)
end
function c101006054.atklimcon(e)
	return e:GetHandler():GetFlagEffect(101006054)~=0 and Duel.IsExistingMatchingCard(c101006054.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101006054.atklimtg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c101006054.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(101006054)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(101006054,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c101006054.atkcon(e)
	local d=Duel.GetAttackTarget()
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and d and d:IsControler(1-tp)
end
function c101006054.atktg(e,c)
	return c==Duel.GetAttacker() and c:IsSetCard(0x221)
end
function c101006054.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c101006054.spfilter(c,e,tp)
	return c:IsSetCard(0x221) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101006054.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101006054.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101006054.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101006054.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
