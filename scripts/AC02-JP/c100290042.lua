--G石人·水晶心
--LUA BY AKAWAKU
function c100290042.initial_effect(c)
	c:EnableCounterPermit(0x2855)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100290042,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c100290042.sptg)
	e1:SetOperation(c100290042.spop)
	c:RegisterEffect(e1) 
	--atk gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c100290042.atkcon)
	e2:SetTarget(c100290042.atktg)
	e2:SetValue(c100290042.atkval)
	c:RegisterEffect(e2)   
	local e3=e2:Clone()
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
end
function c100290042.filter(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c100290042.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100290042.filter(chkc,e,tp,zone) end
	if chk==0 then return Duel.IsExistingTarget(c100290042.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100290042.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100290042.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone&0x1f~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		c:AddCounter(0x2855,1)
	end
end
function c100290042.atkcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c100290042.atktg(e,c)
	local g=e:GetHandler():GetMutualLinkedGroup()
	return (c==e:GetHandler() or g:IsContains(c)) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c100290042.atkval(e,c)
	return e:GetHandler():GetCounter(0x2855)*600
end