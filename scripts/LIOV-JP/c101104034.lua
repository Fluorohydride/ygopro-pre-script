--ミュステリオンの竜冠
--Dracrown of Mysterion
--Scripted by Kohana Sonogami
function c101104034.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),true)
	--cannot be fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--ATK down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(c101104034.atkval)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101104034,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101104034)
	e3:SetTarget(c101104034.remtg)
	e3:SetOperation(c101104034.remop)
	c:RegisterEffect(e3) 
end
function c101104034.atkval(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_REMOVED,0)*-100
end
function c101104034.cfilter(c,e,rc,re)
	return (c:IsFaceup() and re:IsActivated() and rc:IsRace(c:GetOriginalRace()) or rc==c)
		and c:IsCanBeEffectTarget(e) and c:IsAbleToRemove()
end
function c101104034.remtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=re:GetHandler()
	if chkc then return eg:IsContains(chkc) and c101104034.cfilter(chkc,e,rc,re) end
	if chk==0 then return rc and eg:IsExists(c101104034.cfilter,1,nil,e,rc,re) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=eg:FilterSelect(tp,c101104034.cfilter,1,1,nil,e,rc,re)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c101104034.remop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(tc)
		if tc:IsFaceup() then
			g=g+Duel.GetMatchingGroup(aux.FilterBoolFunction(Card.IsRace,tc:GetOriginalRace()),tp,LOCATION_MZONE,LOCATION_MZONE,tc)
		end
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
