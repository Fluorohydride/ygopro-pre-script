--メタファイズ・ファクター
--Metaphys Factor
--Scripted by Eerie Code
function c101002059.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101002059,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c101002059.ntcon)
	e2:SetTarget(c101002059.nttg)
	e2:SetOperation(c101002059.ntop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c101002059.chainop)
	c:RegisterEffect(e3)
end
function c101002059.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c101002059.nttg(e,c)
	return c:IsLevelAbove(5) and (c:IsCode(89189982,36898537) or c:IsSetCard(0x202))
end
function c101002059.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	c:RegisterFlagEffect(101002059,RESET_EVENT+0x1fe0000-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101002059,1))
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetLabel(Duel.GetTurnCount()+1)
	e2:SetLabelObject(c)
	e2:SetCondition(c101002059.rmcon)
	e2:SetOperation(c101002059.rmop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function c101002059.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(101002059)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function c101002059.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c101002059.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if (rc:IsCode(89189982,36898537) or rc:IsSetCard(0x202)) and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(c101002059.chainlm)
	end
end
function c101002059.chainlm(e,rp,tp)
	return tp==rp
end
