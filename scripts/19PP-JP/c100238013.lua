--幻魔帝トリロジーグ
--
--Script by mercury233
function c100238013.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsLevel,10),3,false)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100238013,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100238013)
	e1:SetTarget(c100238013.target)
	e1:SetOperation(c100238013.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100238013.contition2)
	c:RegisterEffect(e2)
end
function c100238013.filter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function c100238013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100238013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100238013.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100238013.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.ceil(g:GetFirst():GetBaseAttack()/2))
end
function c100238013.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,math.ceil(tc:GetBaseAttack()/2),REASON_EFFECT)
	end
end
function c100238013.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function c100238013.contition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not eg:IsContains(c) and eg:IsExists(c100238013.cfilter,1,nil,tp)
end
