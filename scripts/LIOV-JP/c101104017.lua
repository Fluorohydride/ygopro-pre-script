--Live☆Twin キスキル・フロスト
--Live☆Twin Ki-sikil Frost
--Scripted by Kohana Sonogami
function c101104017.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101104017+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101104017.spcon)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1,101104017+100)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c101104017.drcon)
	e2:SetTarget(c101104017.drtg)
	e2:SetOperation(c101104017.drop)
	c:RegisterEffect(e2)
end
function c101104017.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x153)
end
function c101104017.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c101104017.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c101104017.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_EFFECT)
end
function c101104017.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2151)
end
function c101104017.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101104017.cfilter,1,nil,1-tp) and rp==1-tp
		and Duel.IsExistingMatchingCard(c101104017.drfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101104017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101104017.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
