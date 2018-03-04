--空牙団の豪傑 ダイナ
--
--Scripted by Eerie Code
function c100408021.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100408021)
	e1:SetTarget(c100408021.rmtg)
	e1:SetOperation(c100408021.rmop)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c100408021.atlimit)
	c:RegisterEffect(e2)
end
function c100408021.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x114)
end
function c100408021.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100408021.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()~=0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
end
function c100408021.rmop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(c100408021.filter,tp,LOCATION_MZONE,0,nil)
	local ct=cg:GetClassCount(Card.GetCode)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c100408021.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x114) and c~=e:GetHandler()
end
