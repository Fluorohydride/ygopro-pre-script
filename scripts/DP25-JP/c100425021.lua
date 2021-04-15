--花騎士団の白馬
--Script by XyLeN
function c100425021.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,100425021+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100425021.spcon)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100425021,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100425021)
	e2:SetCondition(c100425021.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100425021.negtg)
	e2:SetOperation(c100425021.negop)
	c:RegisterEffect(e2)
end
function c100425021.spfilter(c)
	return c:IsFaceup() and c:IsLevel(2)
end
function c100425021.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c100425021.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c100425021.negcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp
end
function c100425021.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and aux.TRUE(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100425021.negop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.NegateAttack()~=0 then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
