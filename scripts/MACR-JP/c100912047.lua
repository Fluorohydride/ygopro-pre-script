--十二獣ハマーコング
--Zoodiac Hammerkong
--Scripted by Eerie Code
function c100912047.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c100912047.ovfilter,aux.Stringid(100912047,0),5,c100912047.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100912047.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c100912047.defval)
	c:RegisterEffect(e2)
	--Cannot be effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c100912047.efftg)
	e3:SetCondition(c100912047.effcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--remove material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100912047,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c100912047.rmcon)
	e4:SetOperation(c100912047.rmop)
	c:RegisterEffect(e4)
end
function c100912047.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(100912047)
end
function c100912047.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100912047)==0 end
	Duel.RegisterFlagEffect(tp,100912047,RESET_PHASE+PHASE_END,0,1)
end
function c100912047.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c100912047.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100912047.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c100912047.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c100912047.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100912047.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c100912047.efftg(e,c)
	return c:IsSetCard(0xf1) and c~=e:GetHandler()
end
function c100912047.effcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c100912047.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100912047.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
