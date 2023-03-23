--Recette de Spécialité～料理長自慢のレシピ～
--Script by 小壶
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.relcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.reltg)
	e2:SetOperation(s.relop)
	c:RegisterEffect(e2)
end
--Activate
function s.conf1(c)
	return c:IsFaceup() and c:IsSetCard(0x196) and c:GetType()&0x81==0x81
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.conf1,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.opf1(c)
	return c:IsFaceup() and c:IsSetCard(0x196) and c:GetType()&0x81==0x81 and c:GetFlagEffect(100420029)>0
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) and rc:IsDestructable() and Duel.IsExistingMatchingCard(s.opf1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
--release
function s.conf2(c,tp)
	return c:IsCode(30243636) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.relcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.conf2,1,nil,tp)
end
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,1,nil) end
end
function s.relop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Release(g,REASON_EFFECT)
	end
end