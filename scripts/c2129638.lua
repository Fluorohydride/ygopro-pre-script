--Blue-Eyes Twin Burst Dragon
--By: HelixReactor
function c2129638.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,89631139,2,true,true)
	--Spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c2129638.splimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c2129638.spcon)
	e1:SetOperation(c2129638.spop)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(c2129638.dircon1)
	e4:SetOperation(c2129638.dirop1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCondition(c2129638.dircon2)
	e5:SetOperation(c2129638.dirop2)
	c:RegisterEffect(e5)
	--Banish
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetCondition(c2129638.rmcon)
	e6:SetOperation(c2129638.rmop)
	c:RegisterEffect(e6)
end
function c2129638.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c2129638.spfilter(c)
	return c:IsFaceup() and c:IsCode(89631139) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c2129638.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c2129638.spfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,2,nil)
end
function c2129638.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c2129638.spfilter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c2129638.dircon1(e)
	return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c2129638.dirop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+RESET_END)
	c:RegisterEffect(e1)
end
function c2129638.dircon2(e)
	return e:GetHandler():IsDirectAttacked()
end
function c2129638.dirop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+RESET_END)
	c:RegisterEffect(e1)
end
function c2129638.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if not c:IsRelateToBattle() then return false end
	if c==Duel.GetAttacker() then
		tc=Duel.GetAttackTarget()
	end
	if tc and tc:IsLocation(LOCATION_MZONE) then
		e:SetLabelObject(tc)
		return true
	else
		return false
	end
end
function c2129638.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
