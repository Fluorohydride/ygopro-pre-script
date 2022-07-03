--Byssted Druidwurm
local s,id,o=GetID()
function s.initial_effect(c)
	--You can only use each effect of "Byssted Druidwurm" once per turn.
	--You can target 1 LIGHT or DARK monster in either GY; banish it, and if you do, Special Summon this card from your hand. This is a Quick Effect if your opponent controls a monster.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(function(e,tp) return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 end)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(function(e,tp) return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end)
	c:RegisterEffect(e2)
	--If this card is sent from the field to the GY: You can target 1 opponent's Special Summoned monster; send it to the GY.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+o)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCondition(function() return c:IsPreviousLocation(LOCATION_ONFIELD) end)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToRemove()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.cfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain(0) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToChain(0) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsSummonType(SUMMON_TYPE_SPECIAL) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(aux.AND(Card.IsSummonType,Card.IsAbleToGrave),tp,0,LOCATION_MZONE,1,nil,SUMMON_TYPE_SPECIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,Duel.SelectTarget(tp,aux.AND(Card.IsSummonType,Card.IsAbleToGrave),tp,0,LOCATION_MZONE,1,1,nil,SUMMON_TYPE_SPECIAL),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain(0) then Duel.SendtoGrave(tc,REASON_EFFECT) end
end
