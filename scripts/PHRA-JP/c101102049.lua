--プランキッズ・ミュー
--
--Script by mercury233
function c101102049.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c101102049.mfilter,1,1)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101102049.condition)
	e1:SetOperation(c101102049.regop)
	c:RegisterEffect(e1)
	--release replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_RELEASE_REPLACE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,101102049)
	e2:SetTarget(c101102049.reptg)
	e2:SetValue(c101102049.repval)
	e2:SetOperation(c101102049.repop)
	c:RegisterEffect(e2)
end
function c101102049.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkSetCard(0x120)
end
function c101102049.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101102049.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c101102049.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101102049.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(101102049) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c101102049.repfilter(c,tp,re)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x120) and c:IsReason(REASON_COST)
		and c==re:GetHandler() and not c:IsReason(REASON_REPLACE)
end
function c101102049.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==1-tp and eg:IsExists(c101102049.repfilter,1,nil,tp,re)
		and e:GetHandler():IsAbleToRemoveAsCost() end
	return Duel.SelectYesNo(tp,aux.Stringid(101102049,0))
end
function c101102049.repval(e,c)
	return c101102049.repfilter(c,e:GetHandlerPlayer(),c:GetReasonEffect())
end
function c101102049.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST+REASON_REPLACE)
end
