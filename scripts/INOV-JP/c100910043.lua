--花札衛－猪鹿蝶－
--Cardian - Inoshikacho
--Script by dest
function c100910043.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(nil,aux.NonTuner(nil),2,2))
	e1:SetTarget(aux.SynTarget(nil,aux.NonTuner(nil),2,2))
	e1:SetOperation(aux.SynOperation(nil,aux.NonTuner(nil),2,2))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe6))
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100910043,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100910043.cost)
	e3:SetOperation(c100910043.operation)
	c:RegisterEffect(e3)
end
function c100910043.spfilter(c)
	return c:IsSetCard(0xe6) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c100910043.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100910043.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100910043.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100910043.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c100910043.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTarget(c100910043.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c100910043.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c100910043.splimit(e,c)
	return c:IsLocation(LOCATION_GRAVE)
end
