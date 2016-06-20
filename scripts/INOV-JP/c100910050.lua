--超化合獣メタン・ハイド
--Super Chemical Beast Methane Hyd
--Script by nekrozar
function c100910050.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_DUAL),8,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100910050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100910050.spcon)
	e1:SetTarget(c100910050.sptg)
	e1:SetOperation(c100910050.spop)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c100910050.con)
	e2:SetValue(c100910050.atlimit)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetCondition(c100910050.con)
	e3:SetValue(c100910050.tglimit)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100910050,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c100910050.tgcon)
	e4:SetCost(c100910050.tgcost)
	e4:SetTarget(c100910050.tgtg)
	e4:SetOperation(c100910050.tgop)
	c:RegisterEffect(e4)
end
function c100910050.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c100910050.spfilter(c,e,tp)
	return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100910050.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and  c100910050.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100910050.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100910050.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100910050.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100910050.con(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c100910050.atlimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL)
end
function c100910050.tglimit(e,re,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_DUAL)
end
function c100910050.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_DUAL)
end
function c100910050.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100910050.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function c100910050.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
